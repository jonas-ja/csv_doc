class DocsController < ApplicationController
  require 'smarter_csv'
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def new
  end

  def create
    # begin
      uploaded = params[:file]
      File.open("./tmp/csv_doc.csv", 'w') do |file|
        file.write(uploaded.read)
      end

      lines = SmarterCSV.process('./tmp/csv_doc.csv')
      @new_hash = lines

      lines.each_with_index do |l1, index1|
        @new_hash.each_with_index do |l2, index2|
          if index1 != index2
            if (lines[index1][:nombre].to_s == @new_hash[index2][:nombre].to_s) && (lines[index1][:correo_electronico].to_s == @new_hash[index2][:correo_electronico].to_s) && (lines[index1][:telefono].to_s == @new_hash[index2][:telefono].to_s)
              @new_hash.delete_at(index2)
            end

            if is_valid_email?(@new_hash[index2][:correo_electronico]).nil?
              @new_hash.delete_at(index2)
            end

            if (lines[index1][:nombre].to_s == @new_hash[index2][:nombre].to_s) || (lines[index1][:correo_electronico].to_s == @new_hash[index2][:correo_electronico].to_s) || (lines[index1][:telefono].to_s == @new_hash[index2][:telefono].to_s)
              @new_hash[index1][:flag] = 0
              @new_hash[index2][:flag] = 0
            end
          end
        end
      end
    # rescue
    #   redirect_to root_path
    # end
  end

  private
    def is_valid_email? email
      email =~ VALID_EMAIL_REGEX
    end

    def deep_copy(o)
      Marshal.load(Marshal.dump(o))
    end

end