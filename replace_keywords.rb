#! ruby -EUTF-8
# -*- mode:ruby; coding:utf-8 -*-

require 'find'

# Initialize
keywords = []

# Picking up keywords for localization
keyword_src_path = Dir::getwd + "/keywords/src"
Find.find(keyword_src_path) do |path|
  next unless !File.directory?(path)
  if path[path.length-"list".length, "list".length] === "list" then
    text_fetch_flag = false
    text_en = ""
    text_jp = ""
    source_file = IO.readlines path
    source_file.each do |data|
      data = data.chomp
      if data.length > 0 then
        if text_fetch_flag then
          text_jp = data
          text_fetch_flag = false
        else
          text_en = data.gsub(/([\^\'\?"\(\)\*\[\]])/, "\\\\\\1")
          text_fetch_flag = true
        end
      else
        if text_jp != "" && text_en != "" then
          keywords << {
            :en => text_en,
            :jp => text_jp
          }
          text_en = ""
          text_jp = ""
          text_fetch_flag = false
        end
      end
    end
    if text_jp != "" && text_en != "" then
          keywords << {
            :en => text_en,
            :jp => text_jp
          }
    end
  end
end

# Replacing the keywords
text = File.read( Dir::getwd + "/learnGitBranching/build/bundle.js")
keywords.each do |data|
  if !text.gsub!(/#{data[:en]}/, data[:jp]) then
    # Keywords failed to replace will be informed
    puts data[:en]
    puts data[:jp]
  end
end

File.open(Dir::getwd + "/learnGitBranching/build/bundle-ja.js",'w'){|f|
  f.write text
}
