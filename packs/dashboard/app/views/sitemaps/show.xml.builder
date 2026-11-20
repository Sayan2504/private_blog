xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc root_url
    xml.changefreq "daily"
    xml.priority "1.0"
  end

  xml.url do
    xml.loc published_posts_url
    xml.changefreq "daily"
    xml.priority "0.9"
  end

  @posts.each do |post|
    xml.url do
      xml.loc post_url(post)
      xml.lastmod post.updated_at.iso8601
      xml.changefreq "weekly"
      xml.priority "0.8"
    end
  end

  @authors.each do |author|
    xml.url do
      xml.loc author_url(author)
      xml.lastmod author.updated_at.iso8601
      xml.changefreq "weekly"
      xml.priority "0.6"
    end
  end
end

