class CroakTableView < HMBlkTableView
  def keyDown(event)
    if (event.keyCode == 36) 
      self.target.send(self.doubleAction, self)
    else
      super_keyDown(event)
    end
  end
end