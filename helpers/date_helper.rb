require "tzinfo"

module DateHelper
  FOLDER_DT_FMT = -"%B_%Y"
  DEF_DT_FMT = -"%B"
  TZ = ENV.fetch("TZ", "America/Buenos_Aires")

  module InstanceMethods
    def parse_date(dt)
      begin
        Date.strptime(dt, FOLDER_DT_FMT)
      rescue ArgumentError; end
    end

    def format_date(dt, format: :default)
      case format
      when :folder then dt.strftime(FOLDER_DT_FMT)
      else dt.strftime(DEF_DT_FMT)
      end
    end

    def today
      t = Time.now.utc
      period = tz.period_for_utc(t)
      beginning_of_day = Time.utc(t.year, t.month, t.day) + period.utc_offset*-1
      beginning_of_day.to_date
    end

    def tz
      @tz ||= TZInfo::Timezone.get(TZ)
    end
  end

  module RequestMethods
    include InstanceMethods

    def current_year
      @current_year ||= begin
                          yr = self["year"]
                          yr ? Integer(yr) : today.year
                        end
    end
  end
end

Roda.plugin(DateHelper) if defined?(Roda)
