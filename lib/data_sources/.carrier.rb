require 'digest'

module NanocSite
  
  class CarrierDataSource < Nanoc::DataSource

    identifier :carriers

    def items
      items = [] 
    
      prefix = '/carriers'

      # get all files under prefix dir
      filenames = Dir[prefix + '/**/*'].select { |f| File.file?(f) }

      # convert to imtes
      filenames.map do |fn|
        attributes = {
          extension: File.extname(fn)[1..-1],
          filename: fn,
          mtime: File.mtime(fn)
        }

        identifier = fn[(prefix.length+1)..-1] + '/'
    
        checksum = checksum_for(fn)

        Nanoc::Item.new(
          fn,
          attributes,
          identifier,
          binary: true, checksum: checksum
        )
      end
    end

    private

      def checksum_for(*filenames)
        filenames.flatten.map do |fn|
          digest = Digest::SHA1.new
          File.open(fn, 'r') do |io|
            until io.eof
              data = io.readpartial(2**10)
              digest.update(data)
            end
          end
          digest.hexdigest
        end.join('-')
      end
  end

end
