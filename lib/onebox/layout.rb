module Onebox
  class Layout < Mustache
    VERSION = "1.0.0"

    attr_reader :cache
    attr_reader :record
    attr_reader :view

    self.template_name = "_layout"
    self.template_path = File.join(Gem::Specification.find_by_name("onebox").gem_dir, "templates")


    def initialize(name, record, cache)
      @cache = cache
      @record = record
      @md5 = Digest::MD5.new
      @view = View.new(name, record)
    end

    def to_html
      if cache.key?(checksum)
        cache.fetch(checksum)
      else
        cache.store(checksum, render(details))
      end
    end

    private

    def checksum
      @md5.hexdigest("#{VERSION}:#{link}")
    end

    def link
      record[:link]
    end

    def details
      {
        link: record[:link],
        title: record[:title],
        badge: record[:badge],
        domain: record[:domain],
        subname: view.template_name,
        view: view.to_html
      }
    end
  end
end
