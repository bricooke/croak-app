#
#  CroakController.rb
#  Croak
#
#  Created by Brian Cooke on 8/21/08.
#  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
#
class CroakController < NSObject
  ib_outlet :errors_array_controller, :window_controller, :application_controller, :progress
  ib_outlet :errors_table_view
  
  kvc_accessor :refreshing
  
  def initialize
    @refreshed = 0
  end
    
  def refresh_errors
    self.refreshing = true
    
    go_green = false
    @progress.startAnimation(self)
    @errors_array_controller.content.removeAllObjects
    
    previous_errors = @recent_errors || []
    @recent_errors = HoptoadInfo.recent_errors
    @recent_errors.each do |e|
      if !previous_errors.include?(e)
        go_green = true 
        @application_controller.growl.notify('New error', e.error_message, e.last_notice_at.to_s(:short) + " " + e.notices_count.to_s) if @refreshed > 0
      end
      @errors_array_controller.insertObject_atArrangedObjectIndex(e.to_hash, 0)
    end
    @errors_table_view.reloadData
    
    @errors_table_view.reloadData
    @window_controller.showErrors
    @window_controller.go_green(self) if go_green
    
    @refreshed += 1
    self.refreshing = false
  end
  
  def error(index)
    @errors_array_controller.arrangedObjects.objectAtIndex(index)
  end
end
