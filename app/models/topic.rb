class Topic < ActiveRecord::Base
  belongs_to :forum
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :posts

  attr_accessor :body

  validates_presence_of :subject
  after_save :create_first_post

  attr_accessible :subject, :body

  def paginate_posts_sorted(per_page, current)
    posts.find :all, :order => "created_at ASC", :page => { :size => per_page, :first => 1, :current => current }
  end

  def last_post()
    posts.find :first, :order => "created_at DESC"
  end

  def replies_count()
    posts.count-1
  end

  def page_with_post(per_page, post)
    posts = paginate_posts_sorted(per_page, 1)
    (1..posts.page_count).detect do |page|
      posts.move! page
      !posts.detect { |tmp_post| tmp_post.id == post.id }.nil?
    end
  end

  def self.paginate_search_topics(per_pages, current, params)
    # slowa kluczowe
    keywords = params[:keywords].to_s.split
    # czy sa slowa kluczowe lub podany autor
    unless keywords.empty? and params[:author].blank?
      # autor postu lub tematu
      author = User.find_by_login params[:author]
      unless keywords.empty? and author.nil?
        # preparowanie warunkow
        tab = []
        # warunki dla slow kluczowych
        tab << conditions_for_keywords("posts", keywords, author) if ["1", "2"].include? params[:search_in].to_s
        tab << conditions_for_keywords("topics", keywords, author) if ["1", "3"].include? params[:search_in].to_s
        tab = [join_conditions(tab, "OR")]
        # warunek dla forum
        tab = join_conditions([tab, ["topics.forum_id", params[:forum]]]) if [nil, ""].include? params[:forum].nil?
        # warunek
        conditions = join_conditions(tab)
        # szukanie tematow
        find :all, :include => :posts, :conditions => conditions, :order => "posts.created_at DESC", :page => { :size => per_pages, :first => 1, :current => current }
      else
        find :all, :limit => 0, :page => { :size => per_pages, :first => 1, :current => current }
      end
    else
      nil
    end
  end

  def self.like_escape(s)
    s.gsub(/\\|%|_/) { |match| "\\#{match}" }
  end

  def self.conditions_for_author(table, author)
    ["#{table}.author_id = ?", author.id]
  end

  def self.conditions_for_keywords(table, keywords, author = nil)
    unless keywords.empty?
      column = (table.to_s == "topics" ? "#{table}.subject" : "#{table}.body")
      tab = join_conditions((keywords.collect { |keyword| ["UPPER(#{column}) LIKE ?", "%#{like_escape keyword.upcase}%"] }), "OR")
      tab = join_conditions([tab, conditions_for_author(table, author)]) unless author.nil?
      tab
    else
      conditions_for_author(table, author)
    end
  end

  def self.join_conditions(tab, op = "AND")
    [tab.delete_if { |tmp|  tmp.nil?}.collect { |condition| "(#{condition[0]})" }.join " #{op} "]+tab.collect { |condition| condition[1..-1] }.flatten
  end

  protected
  def create_first_post()
    if self.posts.empty?
      first_post = Post.new(:body => self.body)
      first_post.author = self.author
      self.posts << first_post
      first_post.save
    end
  end

end
