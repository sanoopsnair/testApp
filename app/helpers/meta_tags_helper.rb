module MetaTagsHelper
  def meta_tags
    return "" unless @meta_tags
    @meta_tags.reverse_merge!(
      "robots" => :all,
      "viewport" => "width=device-width, initial-scale=1.0",
      "copyright" => "2015 K P Varma",
      "content-language" => "en",
      "resource-type" => "document",
      "distribution" => "global",
      "rating" => "general"
    )

    link_tags_list = []
    meta_tags_list = []

    {
      prev: :rel_prev,
      next: :rel_next,
      canonical: :canonical
    }.each do |k, v|
      link_tags_list << content_tag(:link, "", rel: k, href: v) if @meta_tags[k]
    end

    {
      meta_description: :meta_description,
      meta_keywords: :meta_keywords,
      keywords: :keywords,
      robots: :robots
    }.each do |k, v|
      meta_tags_list << content_tag(:meta, "", name: k, content: v) if @meta_tags[k]
    end

    raw(link_tags_list.join(" ") + meta_tags_list.join(" "))

  end
end
