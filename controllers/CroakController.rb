#
#  CroakController.rb
#  Croak
#
#  Created by Brian Cooke on 8/21/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#

require 'osx/cocoa'

class CroakController < OSX::NSObject
  include OSX
  
  def tableView_objectValueForTableColumn_row(tv, column, index)
    case column.identifier
      when "timestamp"
        Time.now
      else
        "Test #{index}"
    end
  end
  
  def numberOfRowsInTableView(tv)
    return 100
  end
end
