xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "MindCanvas"
    xml.description "Published stories on MindCanvas"
    xml.link published_posts_url

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.author post.author.presence || post.user&.display_name
        xml.pubDate post.published_at.to_fs(:rfc822)
        xml.link post_url(post)
        xml.guid post_url(post)
        xml.description post.content.to_plain_text.truncate(300)
      end
    end
  end
end

