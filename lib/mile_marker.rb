module Thoughtbot
  module MileMarkerHelper
    def todo(detail="")
      return unless MileMarker.enabled?
      "todo=\"#{detail}\""
    end
  
    def initialize_mile_marker(request = nil)
      return unless MileMarker.enabled?
      MileMarker.initialize_mile_marker()
    end
  
    def add_initialize_mile_marker()
      init_code = initialize_mile_marker()
      return if init_code.blank?
      response.body.gsub! /<\/(head)>/i, init_code + '</\1>' if response.body.respond_to?(:gsub!)
    end
  end
    
  class MileMarker  
    # The environments in which to enable the Todo functionality to run.  Defaults
    # to 'development' only.
    @@environments = ['development']
    cattr_accessor :environments

    # Return true if the Todo functionality is enabled for the current environment
    def self.enabled?
      environments.include?(ENV['RAILS_ENV'])
    end
    
    def self.initialize_mile_marker()
      %Q~
<script type="text/javascript">
//<![CDATA[
  function init_todo() {
    $$('*[todo]').each(function(block, index) {
      html = '<div id="todo_'+index+'" style="display: none; z-index: 1000; position: absolute; background-color: #000; opacity: .33; filter: alpha(opacity=33); color: #fff; font-family: Verdana; font-weight: bold; font-size: 20px;"><div style="margin: 5px;">'+block.getAttribute('todo')+'</div></div>'
      new Insertion.Before($(block), html);
      Position.clone($(block), $('todo_'+index));
      $('todo_'+index).toggle();
    });
  }
  Event.observe(window, 'load', init_todo, false);
//]]>
</script>
~
    end 
  end
end