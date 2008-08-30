class Duration
  module Localizations
    # English localization
    module English
      LOCALE    = :english
      PLURALS   = %w(seconds minutes hours days weeks)
      SINGULARS = %w(second minute hour day week)
      FORMAT    = proc do |duration|
    		str = duration.format('%w %~w, %d %~d, %h %~h, %m %~m, %s %~s')
    		str.sub(/^0 [a-z]+,?/i, '').gsub(/ 0 [a-z]+,?/i, '').chomp(',').sub(/, (\d+ [a-z]+)$/i, ' and \1').strip
    	end
    end
  end
end