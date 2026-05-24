puts "Seeding posts..."

posts_data = [
  {
    title: "The Future of Web Development in 2026",
    subtitle: "How AI, edge computing, and new frameworks are reshaping how we build for the web",
    author: "Sayan",
    content: "<p>The web development landscape has undergone a remarkable transformation. With the rise of AI-assisted coding, edge-first architectures, and frameworks that prioritize developer experience, 2026 is proving to be a pivotal year.</p><h2>AI as a Coding Partner</h2><p>Gone are the days when AI was merely a fancy autocomplete. Today's AI tools understand context, suggest architectural decisions, and can even write entire test suites. But the human developer remains essential — providing creativity, domain knowledge, and the critical thinking that no model can replicate.</p><h2>Edge Computing Goes Mainstream</h2><p>With serverless functions running at the edge becoming the default deployment model, applications are faster than ever. The gap between server-rendered and client-rendered experiences has all but disappeared.</p><blockquote>The best code is the code that doesn't need to exist. The best architecture is one that's invisible to the user.</blockquote><p>As we look ahead, the trend is clear: simpler tools, smarter defaults, and more time spent on what actually matters — solving real problems for real people.</p>",
    published_at: 2.days.ago
  },
  {
    title: "Why I Switched from React to Hotwire",
    subtitle: "Sometimes less JavaScript means more productivity",
    author: "Sayan",
    content: "<p>After five years of building React SPAs, I made the switch to Hotwire and Rails. Here's what I learned — and why I'm not looking back.</p><h2>The Complexity Tax</h2><p>React is powerful. But with power comes complexity. State management libraries, build tooling, TypeScript configurations, API layers — the overhead of a modern React app is enormous.</p><h2>Hotwire's Simplicity</h2><p>With Turbo and Stimulus, I get 90% of the interactivity with 10% of the JavaScript. Forms just work. Navigation is instant. And I can build features in hours instead of days.</p><p>The key insight: most web applications don't need a JavaScript framework. They need fast, reliable HTML responses with sprinkles of interactivity.</p><h2>When React Still Makes Sense</h2><p>For highly interactive UIs like design tools, real-time collaboration apps, or complex dashboards, React (or similar) still has its place. But for content sites, CRUD apps, and most SaaS products? Hotwire is a revelation.</p>",
    published_at: 5.days.ago
  },
  {
    title: "Building a Blog That Sparks Joy",
    subtitle: "Design principles for personal publishing platforms",
    author: "Sayan",
    content: "<p>Your blog should be a reflection of your thinking — clear, intentional, and beautiful. Here's how I approach designing personal publishing platforms.</p><h2>Typography First</h2><p>Great blogs start with great typography. Choose a readable font size (18px minimum for body text), generous line height (1.6-1.8), and limit line length to 65-75 characters.</p><h2>Whitespace is Content</h2><p>Don't fear empty space. It gives your words room to breathe and helps readers focus on what matters. A cramped layout signals amateur design.</p><h2>Speed is a Feature</h2><p>Every millisecond counts. Use server-side rendering, minimize JavaScript, optimize images, and cache aggressively. A fast blog shows respect for your readers' time.</p><ul><li>Load time under 1 second</li><li>No layout shift</li><li>Works without JavaScript</li><li>Accessible to everyone</li></ul><p>Remember: the best blogs are the ones people actually read. Make that easy.</p>",
    published_at: 1.week.ago
  }
]

posts_data.each do |data|
  post = Post.create!(
    title: data[:title],
    subtitle: data[:subtitle],
    author: data[:author],
    published_at: data[:published_at]
  )
  post.content = ActionText::Content.new(data[:content])
  post.save!
  puts "  Created: #{post.title}"
end

puts "Done! Created #{Post.count} posts."
