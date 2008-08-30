#
#  CroakController.rb
#  Croak
#
#  Created by Brian Cooke on 8/21/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#
class CroakController < NSObject
  ib_outlet :errors_array_controller, :window_controller, :progress
  
  def refresh_errors
    go_green = false
    @progress.startAnimation(self)
    @errors_array_controller.content.removeAllObjects
    
    previous_errors = @recent_errors || []
    @recent_errors = HoptoadInfo.recent_errors
    @recent_errors.each do |e|
      go_green = true if !previous_errors.include?(e)
      @errors_array_controller.insertObject_atArrangedObjectIndex(e.to_hash, 0)
    end
    @window_controller.showErrors
    @window_controller.go_green(self) if go_green
  end
  
  def error(index)
    @errors_array_controller.arrangedObjects.objectAtIndex(index)
  end
end
