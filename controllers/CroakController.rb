#
#  CroakController.rb
#  Croak
#
#  Created by Brian Cooke on 8/21/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#
class CroakController < NSObject
  ib_outlet :errors_array_controller, :window_controller
  
  def awakeFromNib
    refresh_errors
    
    Thread.new do
      while true
        sleep 300
        refresh_errors
      end
    end
  end
  
  def refresh_errors
    Thread.new do
      Error.find(:all).reverse.each do |e|
        if @errors_array_controller.arrangedObjects.indexOfObject(e.to_hash) == NSNotFound
          @errors_array_controller.insertObject_atArrangedObjectIndex(e.to_hash, 0)
          @window_controller.go_green(self)
        end
      end
    end
  end
  
  def table_view_clicked(sender)
  end
end
