/* Compiled and copied assets files in use: 
 - main/js/api.coffee
 - main/js/jquery.serialize-hash.js
 - main/js/pjax.coffee
 - main/js/popup.coffee
 - components/toastr/toastr.coffee
 - main/index.coffee
*/

/* Asset file: main/js/api.coffee */
// Generated by CoffeeScript 1.9.3
(function() {
  this.Api = {
    silent: function(method, opts, func) {
      if (typeof opts === 'function') {
        func = opts;
        opts = {};
      }
      if (!/^\/api/.test(method)) {
        method = "/api/" + method;
      }
      return $.post(method, opts, function(ret) {
        if (func && !ret['error']) {
          return func(ret);
        }
      });
    },
    send: function(method, opts, func) {
      if (typeof opts === 'object') {
        opts = $(opts).serializeHash();
      }
      if (typeof opts === 'function') {
        func = opts;
        opts = {};
      }
      if (!/^\/api/.test(method)) {
        method = "/api/" + method;
      }
      return $.post(method, opts, function(ret) {
        Info.auto(ret);
        if (func && !ret['error']) {
          return func(ret);
        }
      });
    },
    rails_form: function(node, on_success) {
      var form, key, ref, val;
      node = $(node);
      node.find('button').each(function() {
        return $(this).disable('Saveing...', 2000);
      });
      form = node.closest('form');
      ref = form.serializeHash();
      for (key in ref) {
        val = ref[key];
        if (is_.o(val)) {
          Api.send(form.attr('action'), val, on_success);
        }
      }
      return false;
    }
  };

}).call(this);


/* Asset file: main/js/jquery.serialize-hash.js */
(function($){
  $.fn.serializeHash = function() {
    var hash = {};
    /***
     JQuery plugin that returns a hash from serialization of any form or dom element. It supports Brackets on input names.
     It is convenient if you want to get values from a form and merge it with an other hash for example.

     ** Added by rilinor on 29/05/2012 : jquery serialize hash now support serialization of any dom elements (before, only form were supported). Thanks !

     Example:
     ---------- HTML ----------
     <form id="form">
       <input type="hidden" name="firstkey" value="val1" />
       <input type="hidden" name="secondkey[0]" value="val2" />
       <input type="hidden" name="secondkey[1]" value="val3" />
       <input type="hidden" name="secondkey[key]" value="val4" />
     </form>
     ---------- JS ----------
     $('#form').serializeHash()
     should return :
     {
       firstkey: 'val1',
       secondkey: {
         0: 'val2',
         1: 'val3',
         key: 'val4'
       }
     }
     ***/
    function stringKey(key, value) {
      var beginBracket = key.lastIndexOf('[');
      if (beginBracket == -1) {
        var hash = {};
        hash[key] = value;
        return hash;
      }
      var newKey = key.substr(0, beginBracket);
      var newValue = {};
      newValue[key.substring(beginBracket + 1, key.length - 1)] = value;
      return stringKey(newKey, newValue);
    }

    var els = $(this).find(':input').get();
    $.each(els, function() {
        if (this.name && !this.disabled && (this.checked || /select|textarea/i.test(this.nodeName) || /hidden|text|search|tel|url|email|password|datetime|date|month|week|time|datetime-local|number|range|color/i.test(this.type))) {
            var val = $(this).val();
            $.extend(true, hash, stringKey(this.name, val));
        }
    });
    return hash;
  };
})(jQuery);


/* Asset file: main/js/pjax.coffee */
// Generated by CoffeeScript 1.9.3
(function() {
  this.Pjax = {
    skip_on: [],
    push_state: false,
    refresh: function(func) {
      return Pjax.load(location.pathname + location.search, {
        func: func
      });
    },
    init: function(full_page) {
      this.full_page = full_page != null ? full_page : false;
      if (!this.full_page) {
        return alert("#full_page ID referece not defined in PJAX!\n\nWrap whole page in one DIV element");
      }
      if (window.history && window.history.pushState) {
        Pjax.push_state = true;
        window.history.pushState({
          href: location.href,
          type: 'init'
        }, document.title, location.href);
        return window.onpopstate = function(event) {
          console.log(event.state);
          if (event.state && event.state.href) {
            return Pjax.load(event.state.href, {
              history: true
            });
          } else {
            return history.go(-2);
          }
        };
      }
    },
    skip: function() {
      var el, i, len, results;
      results = [];
      for (i = 0, len = arguments.length; i < len; i++) {
        el = arguments[i];
        results.push(Pjax.skip_on.push(el));
      }
      return results;
    },
    redirect: function(href) {
      location.href = href;
      return false;
    },
    replace: function(title, body) {
      document.title = title;
      $(this.full_page).html(body);
      return $(document).trigger('page:change');
    },
    load: function(href, opts) {
      var el, i, len, ref, speed;
      if (opts == null) {
        opts = {};
      }
      if (!href) {
        return false;
      }
      if (typeof href === 'object') {
        href = $(href).attr('href');
      }
      if (href === '#') {
        return;
      }
      if (/^http/.test(href)) {
        return this.redirect(href);
      }
      if (/#/.test(href)) {
        return this.redirect(href);
      }
      if (!Pjax.push_state) {
        return this.redirect(href);
      }
      ref = Pjax.skip_on;
      for (i = 0, len = ref.length; i < len; i++) {
        el = ref[i];
        switch (typeof el) {
          case 'object':
            if (el.test(href)) {
              return this.redirect(href);
            }
            break;
          case 'function':
            if (el(href)) {
              return this.redirect(href);
            }
            break;
          default:
            if (el === href) {
              return this.redirect(href);
            }
        }
      }
      speed = $.now();
      $.get(href).done((function(_this) {
        return function(data) {
          var body, obj;
          console.log("Pjax.load " + (opts.history ? '(back trigger)' : '') + " " + ($.now() - speed) + "ms: " + href);
          obj = $("<div>" + data + "</div>");
          body = obj.find(_this.full_page).html() || data;
          Pjax.replace(obj.find('title').first().html(), body);
          if (!opts['history']) {
            if (location.href.indexOf(href) > -1) {
              window.history.replaceState({
                href: href,
                type: 'replaced'
              }, document.title, href);
            } else {
              window.history.pushState({
                href: href,
                type: 'pushed'
              }, document.title, href);
            }
          }
          if (window._gaq) {
            _gaq.push(['_trackPageview']);
          }
          if (opts.func) {
            return opts.func();
          }
        };
      })(this)).error(function(ret) {
        return Info.error(ret.statusText);
      });
      return false;
    },
    on_get: function(func) {
      if (func) {
        return $(document).on('page:change', function() {
          return func();
        });
      } else {
        return $(document).trigger('page:change');
      }
    }
  };

}).call(this);


/* Asset file: main/js/popup.coffee */
// Generated by CoffeeScript 1.9.3
(function() {
  window.Popup = {
    close: function() {
      return $('#popup').hide();
    },
    _init: function() {
      var insert;
      if (console.log) {
        console.log('Popup._init()');
      }
      insert = $("<div id=\"popup\" style=\"display:none;\"><span onclick=\"Popup.close();\" style=\"cursor:pointer;float:right;font-size:14px; color:#aaa;\">&#10006;</span><div id=\"popup_title\"></div><div id=\"popup_body\"></div></div>");
      return $(document.body).append(insert);
    },
    button: function() {
      return $($('#popup').data('button'));
    },
    render: function(button, title, data) {
      var left_pos_fix, pbody, popup, there_is_left;
      if (typeof data !== 'string') {
        data = $(data).html();
      }
      this.refresh_button = button = $(button);
      popup = $('#popup');
      if (popup.length === 0) {
        Popup._init();
        popup = $('#popup');
      }
      if (button[0].nodeName !== 'INPUT' && popup.is(':visible') && popup.attr('data-popup-title') === title) {
        popup.hide();
        return;
      }
      popup.attr('data-popup-title', title);
      left_pos_fix = 0;
      there_is_left = $(window).width() - button.offset().left;
      if (there_is_left < 400) {
        left_pos_fix = 400 - there_is_left;
      }
      popup.css('left', button.offset().left - left_pos_fix);
      popup.css('top', button.offset().top + button.height() + ($(button)[0].nodeName === 'INPUT' ? 14 : 6));
      $('#popup_title').html(title);
      $('#popup').data('button', button);
      pbody = $('#popup_body');
      if (/^\//.test(data)) {
        pbody.html('...');
        $.get(data, function(ret) {
          return pbody.html("<widget url=\"" + data + "\">" + ret + "</widget>");
        });
      } else {
        pbody.html(data);
        setTimeout((function(_this) {
          return function() {
            return pbody.find('input').first().focus();
          };
        })(this), 100);
      }
      return popup.show();
    },
    destroy: function(button, text, func) {
      var butt, data;
      data = $("<div style='text-align:center !important;'><button class='btn btn-danger' style='margin:15px auto;'>" + text + "</button> or <button class='btn btn-small'>no</button></div>");
      butt = data.find('button').first();
      data.find('.btn-small').on('click', function() {
        return Popup.close();
      });
      butt.on('mouseover', function() {
        return $(this).transition({
          scale: 1.1
        });
      });
      butt.on('mouseout', function() {
        return $(this).transition({
          scale: 1.0
        });
      });
      butt.on('click', function() {
        return func();
      });
      return Popup.render(button, 'Sure to destroy?', data);
    },
    undelete: function(button, obj, id) {
      var butt, data;
      data = $("<div style='text-align:center;'><button class='btn btn-primary' style='margin:15px auto;;'>undelete?</button> or <button class='btn btn-small'>no</button></div>");
      butt = data.find('button').first();
      data.find('.btn-small').on('click', function() {
        return Popup.close();
      });
      butt.on('mouseover', function() {
        return $(this).transition({
          scale: 1.1
        });
      });
      butt.on('mouseout', function() {
        return $(this).transition({
          scale: 1.0
        });
      });
      butt.on('click', function() {
        return Api.send("/api/" + obj + "/" + id + "/undelete", {}, function() {
          Popup.close();
          return Pjax.load("/" + obj + "/" + id);
        });
      });
      return Popup.render(button, "Recicle object from trash?", data);
    },
    refresh: function() {
      Popup.close();
      return this.refresh_button.click();
    },
    menu: function(button, title, array) {
      var data, el, i, len;
      data = [];
      for (i = 0, len = array.length; i < len; i++) {
        el = array[i];
        data.push("<a class=\"block\" onclick=\"Popup.close();" + el[1] + "\">" + el[0] + "</a>");
      }
      return this.render(button, title, data.join(''));
    },
    data: function(data) {
      $('#popup_body').html(data);
      return Pjax.on_get();
    }
  };

}).call(this);


/* Asset file: components/toastr/toastr.coffee */
// Generated by CoffeeScript 1.9.3
(function() {
  this.Info = {
    ok: function(msg) {
      return Info.show('success', msg);
    },
    info: function(msg) {
      return Info.show('info', msg);
    },
    noteice: function(msg) {
      return Info.show('info', msg);
    },
    success: function(msg) {
      return Info.show('success', msg);
    },
    error: function(msg) {
      return Info.show('error', msg);
    },
    alert: function(msg) {
      return Info.show('error', msg);
    },
    warning: function(msg) {
      return Info.show('warning', msg);
    },
    auto: function(res, follow_redirects) {
      if (typeof res === 'string') {
        res = jQuery.parseJSON(res);
      }
      if (res['info']) {
        Info.show('info', res['info']);
      } else if (res['error']) {
        Info.show('error', res['error']);
      } else {
        if (res['message']) {
          Info.show('info', res['message']);
        } else {
          Info.show('info', res['data']);
        }
      }
      if (res['redirect_to'] && follow_redirects) {
        location.href = res['redirect_to'];
      }
      return true;
    },
    show: function(type, msg) {
      var cont, el;
      if (type === 'notice') {
        type = 'info';
      }
      if (type === 'alert') {
        type = 'error';
      }
      el = $('<div class="toast toast-' + type + '" class="toast-top-right"><div class="toast-message">' + msg + '</div></div>');
      cont = $('#toast-container');
      if (!cont[0]) {
        $('body').append('<div id="toast-container" class="toast-bottom-right"></div>');
        cont = $('#toast-container');
      }
      cont.append(el);
      el.css("top", 0);
      return setTimeout((function(_this) {
        return function() {
          return el.remove();
        };
      })(this), 4500);
    }
  };

  window.alert = Info.error;

}).call(this);


/* Asset file: main/index.coffee */
// Generated by CoffeeScript 1.9.3
(function() {
  $(function() {
    Pjax.init('#full-page');
    Pjax.on_get(function() {
      $('a[href]').click(function() {
        return Pjax.load(this);
      });
      return Popup.close();
    });
    return Pjax.on_get();
  });

  window.delete_object = function(object, id) {
    if (!confirm('Are you shure?')) {
      return;
    }
    return Api.send(object + "/" + id + "/destroy", {}, function() {
      return Pjax.load("/" + object);
    });
  };

  window.restore_object = function(object, id) {
    return Api.send(object + "/" + id + "/undelete", {}, function(data) {
      return Pjax.load(data.path);
    });
  };

  Popup.go = {
    clients: function(button, org_id, on_click) {
      var data;
      Popup.render(button, 'Izaberite klijenta', '...');
      window.modal_click_target = on_click;
      data = "<div style=\"width:350px;\">\n  <input type=\"text\" placeholder=\"traži\" onkeyup=\"$w('#c_in_t').set('q', this.value)\" class=\"form-control\" style=\"width:150px; display:inline-block;\" />\n  <a class=\"btn btn-default fr\" href=\"/orgs/" + org_id + "/new_client\">+ novi klijent</a>\n</div>\n<div id=\"c_in_t\" class=\"widget clients_in_table\" org=\"" + org_id + "\" style=\"max-height:400px;overflow:auto;\"></div>";
      return Popup.data(data);
    },
    form: function(button, title, url, name, value, opts) {
      var form;
      if (opts == null) {
        opts = {};
      }
      form = "<input type=\"text\" class=\"form-control\" name=\"" + name + "\" value=\"" + value + "\" style=\"width:250px;\" id=\"popup_input\" />";
      if (opts['as'] === 'editor') {
        form = "<div style=\"width:500px;\"><textarea id=\"popup_editor\" class=\"widget editor form-control\" name=\"" + name + "\" style=\"width:100%; height:150px;\">" + value + "</textarea></div><br>";
      }
      form = "<form onsubmit=\"_t=this; Api.send('" + url + "', this, function(){ Pjax.refresh(true); }); return false;\" method=\"post\">" + form + "<button class=\"btn btn-primary\" style=\"float:right;\">Create</button></form>";
      Popup.render(button, title, form);
      if (opts['as'] === 'editor') {
        return init_html_editor();
      }
    }
  };

}).call(this);

