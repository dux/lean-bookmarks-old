# input = Input.new(User.first)
# input.string :email
class Input

  def initialize(obj=nil, opts={})
    @obj = obj
    @globals = opts.dup
  end

  # exports @name and @opts globals
  def opts_prepare(name, opts={})
    unless opts[:as]
      data_type = @obj[name].class.name rescue 'String'
      opts[:as] = :checkbox if ['TrueClass','FalseClass'].index(data_type)
    end

    # experimental, figure out collection unless defined
    if name =~ /_id$/ && opts[:as] == :select && !opts[:collection]
      class_name = name.to_s.split('_id')[0].capitalize
      opts[:collection] = eval "#{class_name}.order('name').all"
    end

    opts[:as] ||= :select if opts[:collection]
    opts[:as] ||= :text

    opts[:name] = name.kind_of?(Symbol) && @obj ? "#{@obj.class.name.underscore}[#{name}]" : name
    # opts[:value] ||= @obj[name] if @obj
    opts[:value] ||= @obj.send(name) if @obj

    @label = opts.delete :label
    @wrap = opts.delete(:wrap) || @globals[:wrap]
    @name = name
    # opts[:name] = "_cry:#{Crypt.encrypt(opts[:name])}" if opts[:name]
    @opts = opts
  end

  # if type is written in parameter :as=> use this helper function
  def render(name, opts={})
    opts = opts.dup
    opts_prepare name, opts
    send("as_#{opts.delete(:as)}")
  end

  def prepare_collection(data)
    ret = []
    for el in data
      if data[0].respond_to?(:name)
        ret.push [el.id.to_s, el.name]
      elsif data[0].kind_of?(Array)
        ret.push [el[0].to_s, el[1]]
      else
        ret.push [el.to_s, el]
      end
    end
    ret
  end

  # if you call .memo which is not existant, it translates to .as_memo with opts_prepare first
  # def method_missing(meth, *args, &block)
  #   opts_prepare *args
  #   send "as_#{meth}"
  # end

  #############################
  # custom fields definitions #
  #############################

  def as_string
    @opts[:type] = 'text'
    @opts.tag(:input)
  end
  alias :as_text :as_string

  def as_password
    @opts[:type] = 'password'
    @opts.tag(:input)
  end

  def as_hidden
    @opts[:type] = 'hidden'
    @opts.tag(:input)
  end

  def as_file
    @opts[:type] = 'file'
    @opts.tag(:input)
  end

  def as_textarea
    val = @opts.delete(:value) || ''
    @opts.tag(:textarea, val)
  end
  alias :as_memo :as_textarea

  def as_checkbox
    id = Crypt.uid
    hidden = { :name=>@opts.delete(:name), :type=>:hidden, :value=>@opts[:value] ? 1 : 0, :id=>id }
    @opts[:type] = :checkbox
    @opts[:onclick] = "document.getElementById('#{id}').value=this.checked ? 1 : 0; #{@opts[:onclick]}" 
    @opts[:checked] = @opts.delete(:value) ? 1 : nil
    @opts.tag(:input)+hidden.tag(:input)
  end

  def as_select
    body = []
    collection = @opts.delete(:collection)
    if nullval = @opts.delete(:null)
      body.push %[<option value="">#{nullval}</option>] if nullval
    end
    for el in prepare_collection(collection)
      body.push(%[<option value="#{el[0]}"#{@opts[:value].to_s == el[0] ? ' selected=""' : nil}>#{el[1]}</option>])
    end
    body = body.join("\n")
    @opts.tag(:select, body)
  end

  def as_tag
    id = Crypt.uid
    @opts[:value] = @opts[:value].or([]).join(', ') if @opts[:value].kind_of?(Array)
    @opts[:id] = "#{id}_s"
    @opts[:type] = :text
    @opts[:onkeyup] = %[draw_tag('#{id}')]
    ret = %[
    <script>
       window.draw_tag = window.draw_tag || function (id, val) {
        tags = $.map($('#'+id+'_s').val().split(/\s*,\s*/), function(el) {
          val = el.replace(/\s+/,'-');
          return val ? '<span class="label label-default">'+val+'</span> ' : ''
        });
        $('#'+id).html(tags) 
      }</script>]
    ret += @opts.tag(:input)
    ret += %[<div id="#{id}" style="margin-top:5px;"></div>]
    ret += %[<script>draw_tag('#{id}')</script>]
    ret
  end

  def as_date
    @opts[:type] = 'text'
    @opts[:style] = 'width:100px; display:inline;'
    @opts[:id] = "date_#{Lux.uid}"
    id = "##{@opts[:id]}"
    ret = @opts.tag(:input)
    ret += %[ <button class="btn btn-default btn-sm" onclick="$('#{id}').val('#{DateTime.now.strftime('%Y-%m-%d')}'); return false;">Today</button>]
    for el in [1, 3, 7, 14, 30]
      date = DateTime.now+el.days
      name = el.to_s 
      name += " (#{date.strftime('%a')})" if el < 7
      ret += %[ <button class="btn btn-default btn-sm" onclick="$('#{id}').val('#{(DateTime.now+el.days).strftime('%Y-%m-%d')}'); return false;">+#{name}</button>]
    end
    ret
  end

  def as_user
    button_text = if @opts[:value].to_i > 0
      usr = User.find(@opts[:value])
      "#{usr.name} (#{usr.email})"
    else
      'Select user'
    end

    @opts[:style] = "width:auto;#{@opts[:style]};"
    @opts[:onclick] = %[Popup.render(this,'Select user', '/part/users/single_user?product_id=#{@obj.bucket_id}');return false;]
    @opts.tag :button, button_text
  end

  def as_photo
    @opts[:type] = 'hidden'
    if @opts[:value].present?
      img = Photo.find(@opts[:value])
      @image = %[ <img id="#{@opts[:id]}_image" style="height:34px; cursor:pointer;" src="#{img.thumbnail}" onclick="window.open('#{img.image.remote_url}')" /> <span class="btn btn-default btn-xs" onclick="$('##{@opts[:id]}').val('');$('##{@opts[:id]}_image').remove();$(this).remove();">&times;</span>]
    end
    picker = @opts.tag(:input)
    %[<span class="btn btn-default" onclick="Photo.pick('#{@opts[:id]}', function(id) { alert('Chosen: '+id) })">Select photo</span>#{picker}#{@image}]
  end

  def as_photos
    @opts[:type] = 'text'
    @opts[:style] = 'width:150px; display:inline;'
    @opts[:class] += ' mutiple'
    @images = []
    if @opts[:value].present?
      for el in @opts[:value].split(',').uniq
        img = Photo.find(el.to_i) rescue next
        @images.push %[ <img style="height:34px; cursor:pointer;" src="#{img.thumbnail}" onclick="window.open('#{img.image.remote_url}')" />]
      end
    end
    picker = @opts.tag(:input)
    %[<span class="btn btn-default" onclick="Photo.pick('#{@opts[:id]}', function(id) { alert('Chosen: '+id) })">Add photo</span> #{picker}<div class="images" style="padding-top:5px;">#{@images.join(' ')}</div>]
  end

  def as_admin_password
    @opts[:type] = 'password'
    @opts[:style] = 'display:none;'
    @opts[:value] = ''
    ret = @opts.tag(:input)
    %[<span class="btn btn-default" onclick="$(this).hide();$('##{@opts[:id]}').show().val('').focus()">Set pass</span> #{ret}]
  end

  def as_color
    picker_script = ''
    App.once 'color-picker' do
      picker_script = %[<script>$(function(){ $(".color-picker").spectrum({
          showInput: true,
          className: "full-spectrum",
          showInitial: true,
          showPalette: true,
          showSelectionPalette: true,
          maxPaletteSize: 10,
          preferredFormat: "hex",
          localStorageKey: "spectrum.demo",
          move: function (color) {
              
          },
          show: function () {
          
          },
          beforeShow: function () {
          
          },
          hide: function () {
          
          },
          change: function() {
              
          },
          palette: [
              ["rgb(0, 0, 0)", "rgb(67, 67, 67)", "rgb(102, 102, 102)",
              "rgb(204, 204, 204)", "rgb(217, 217, 217)","rgb(255, 255, 255)"],
              ["rgb(152, 0, 0)", "rgb(255, 0, 0)", "rgb(255, 153, 0)", "rgb(255, 255, 0)", "rgb(0, 255, 0)",
              "rgb(0, 255, 255)", "rgb(74, 134, 232)", "rgb(0, 0, 255)", "rgb(153, 0, 255)", "rgb(255, 0, 255)"], 
              ["rgb(230, 184, 175)", "rgb(244, 204, 204)", "rgb(252, 229, 205)", "rgb(255, 242, 204)", "rgb(217, 234, 211)", 
              "rgb(208, 224, 227)", "rgb(201, 218, 248)", "rgb(207, 226, 243)", "rgb(217, 210, 233)", "rgb(234, 209, 220)", 
              "rgb(221, 126, 107)", "rgb(234, 153, 153)", "rgb(249, 203, 156)", "rgb(255, 229, 153)", "rgb(182, 215, 168)", 
              "rgb(162, 196, 201)", "rgb(164, 194, 244)", "rgb(159, 197, 232)", "rgb(180, 167, 214)", "rgb(213, 166, 189)", 
              "rgb(204, 65, 37)", "rgb(224, 102, 102)", "rgb(246, 178, 107)", "rgb(255, 217, 102)", "rgb(147, 196, 125)", 
              "rgb(118, 165, 175)", "rgb(109, 158, 235)", "rgb(111, 168, 220)", "rgb(142, 124, 195)", "rgb(194, 123, 160)",
              "rgb(166, 28, 0)", "rgb(204, 0, 0)", "rgb(230, 145, 56)", "rgb(241, 194, 50)", "rgb(106, 168, 79)",
              "rgb(69, 129, 142)", "rgb(60, 120, 216)", "rgb(61, 133, 198)", "rgb(103, 78, 167)", "rgb(166, 77, 121)",
              "rgb(91, 15, 0)", "rgb(102, 0, 0)", "rgb(120, 63, 4)", "rgb(127, 96, 0)", "rgb(39, 78, 19)", 
              "rgb(12, 52, 61)", "rgb(28, 69, 135)", "rgb(7, 55, 99)", "rgb(32, 18, 77)", "rgb(76, 17, 48)"]
          ]
      }) });</script>]
    end
    @opts[:class] += ' color-picker'
    %[#{@opts.tag(:input)} #{picker_script}]
  end

  def as_array_values
    name = @opts[:name]
    ret = []
    values = @opts[:value].kind_of?(String) ? @opts[:value].split(',') : @opts[:value]
    for el in @opts[:collection]
      ret.push %[<label style="position:relative; top:4px;">
          <input name="#{name}[#{el[1]}]" value="1" type="checkbox" #{values[el[1]].present? ? 'checked=""' : ''} style="position:relative;top:2px; left:2px;" />
          <span style="margin-right:10px;">#{el[0]}</span>
        </label>]
    end
    ret.join('')
  end

end
