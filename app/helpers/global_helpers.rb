module Merb
  module GlobalHelpers
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
  end
end