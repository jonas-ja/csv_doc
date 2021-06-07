class DocsController < ApplicationController
  require 'smarter_csv'
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def new
  end

  def create
    uploaded = params[:file]
    File.open("./tmp/csv_doc.csv", 'w') do |file|
      file.write(uploaded.read)
    end

    lines = SmarterCSV.process('./tmp/csv_doc.csv')
    @new_hash = lines

    lines.each_with_index do |l1, i|
      @new_hash.each_with_index do |l2, j|
        if i != j
          if (l1[:nombre].to_s == l2[:nombre].to_s) || (l1[:correo_electronico].to_s == l2[:correo_electronico].to_s) || (l1[:telefono].to_s == l2[:telefono].to_s)
            @new_hash[j][:flag] = 0
          end

          if is_valid_email?(l2[:correo_electronico]).nil?
            @new_hash.delete(l2)
          end

          if (l1[:nombre].to_s == l2[:nombre].to_s) && (l1[:correo_electronico].to_s == l2[:correo_electronico].to_s) && (l1[:telefono].to_s == l2[:telefono].to_s)
            @new_hash.delete(l2)
          end
        end
      end
    end
  end

  def is_valid_email? email
    email =~ VALID_EMAIL_REGEX
  end

end