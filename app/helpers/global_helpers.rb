module Merb
  module GlobalHelpers
    def title(*val)
      @title ||= []
      @title << val
    end

    def get_title
      @title ||= []
      "#{@title.reverse.flatten.join(' - ')}"
    end

    def size_text(value)
      if value < 1024
        "#{value}b"
      elsif value < (1024 * 1024)
  	   "%.0fkb" % (value.to_f / 1024)
      elsif (value % (1024 * 1024)).to_f / 1024 < 0.05
        "%.0fmb" % (value.to_f / (1024 * 1024))
  	  else
        "%.1fmb" % (value.to_f / (1024 * 1024))
      end
    end

    def commit_partial(commit, title=nil, &block)
      partial "commits/commit", :commit => commit, :title => title ? title : capture(&block)
    end

    # Returns a Gravatar URL associated with the email parameter.
    def gravatar_url(user, gravatar_options={})
      # Default highest rating.
      # Rating can be one of G, PG, R X.
      # If set to nil, the Gravatar default of X will be used.
      gravatar_options[:rating] ||= nil

      # Default size of the image.
      # If set to nil, the Gravatar default size of 80px will be used.
      gravatar_options[:size] ||= nil 

      # Default image url to be used when no gravatar is found
      # or when an image exceeds the rating parameter.
      gravatar_options[:default] ||= nil

      # Build the Gravatar url.
      grav_url = 'http://www.gravatar.com/avatar.php?'
      grav_url << "gravatar_id=#{Digest::MD5.new.update(user)}" 
      grav_url << "&rating=#{gravatar_options[:rating]}" if gravatar_options[:rating]
      grav_url << "&size=#{gravatar_options[:size]}" if gravatar_options[:size]
      grav_url << "&default=#{gravatar_options[:default]}" if gravatar_options[:default]
      return grav_url
    end

    # Returns a Gravatar image tag associated with the email parameter.
    def gravatar(user, gravatar_options={})
      # Set the img alt text.
      alt_text = 'Gravatar'

      # Sets the image sixe based on the gravatar_options.
      img_size = gravatar_options.include?(:size) ? gravatar_options[:size] : '32'

      "<img src=\"#{gravatar_url(user, gravatar_options)}\" alt=\"#{alt_text}\" height=\"#{img_size}\" width=\"#{img_size}\" class=\"avatar\" align=\"left\" />"
    end
  end
end