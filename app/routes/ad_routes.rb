# frozen_string_literal: true

class AdRoutes < Application
  helpers PaginationLinks, Auth

  namespace '/v1' do
    get do
      page = params[:page].presence || 1
      ads = Ad.reverse_order(:updated_at)
              .paginate(page.to_i, Settings.pagination.page_size)

      status :ok
      AdSerializer.new(ads.all, links: pagination_links(ads)).serialized_json
    end

    post do
      ad_params = validate_with!(AdParamsContract)
      result = Ads::CreateService.call(ad_params[:ad], user_id: user_id)

      if result.success?
        status :created
        AdSerializer.new(result.ad).serialized_json
      else
        status :unprocessable_entity
        errors_response(result.ad)
      end
    end
  end
end
