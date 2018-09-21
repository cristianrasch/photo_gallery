module FoldersHelper
  module InstanceMethods
    def group_folders_by_year(folders)
      @folders_by_year ||= folders.map { |folder| Picture.parse_date(folder) }.
                                   reject { |dt, _| !dt }.
                                   group_by(&:year)
    end
  end
end

Roda.plugin(FoldersHelper)
