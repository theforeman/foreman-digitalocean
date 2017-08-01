module DigitaloceanImagesHelper
  def digitalocean_image_field(f)
    images = @compute_resource.available_images
    images.each { |image| image.name = image.id if image.name.nil? }
    select_f f, :uuid, images.to_a.sort_by(&:full_name),
             :id, :full_name, {}, :label => _('Image')
  end

  def select_image(f, compute_resource)
    images = possible_images(compute_resource, nil, nil)

    select_f(f,
             :image_id,
             images,
             :id,
             :slug,
             { :include_blank => images.empty? || images.size == 1 ? false : _('Please select an image') },
             { :label => 'Image', :disabled => images.empty? })
  end

  def select_region(f, compute_resource)
    regions = compute_resource.regions
    f.object.region = compute_resource.region
    select_f(f,
             :region,
             regions,
             :slug,
             :slug,
             {},
             :label => 'Region',
             :disabled => compute_resource.images.empty?)
  end
end
