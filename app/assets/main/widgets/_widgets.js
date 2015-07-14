// .w.toggle{ :title=>'Click me' }
// 
// Widget.register('toggle', {
//   init: function() { 
//     if (! this.opts.title) {
//       this.opts.title = 'no buttle title';
//     }
//   },
//   render: function() {
//     this.root.innerHTML = '<button onclick="$w(this).destroy();">'+this.get('title')+'</button>';
//   },
//   toggle: function() { return 1; }
// });
//
// Widget.load_all();
//
// widget.set('name', 'John');
// widget.render();
//
// onclick="$w(this).toggle()"

(function(){
  "use strict";

  window.Widget = {
    count: 0,
    widgets: {},
    registered_widgets: {},

    register: function(name, obj) {
      this.registered_widgets[name] = obj;
    },

    load_all: function(root) {
      var i, id;
      if (root == undefined) { root = window.document; }
      var widgets = root.getElementsByClassName('w');
      for (i in widgets) {
        var node = widgets[i];
        if (! node.nodeName) { continue; }
        
        // continue if allready loaded
        id = node.getAttribute(id);
        if (id) {
          if (this.widgets[id]) { continue; }
        }

        Widget.bind_to_dom_node(node);
      }
    },

    bind_to_dom_node: function(dom_node) {
      var i, key;

      var klass = dom_node.getAttribute('class');

      // set node_id unless defined
      var node_id = dom_node.getAttribute('id');
      if (!node_id) {
        ++this.count;
        node_id = "widget-" + this.count;
        dom_node.setAttribute('id', node_id);
      }

      // fill with node attributes
      var data = {};
      for (i in dom_node.attributes) {
        var el = dom_node.attributes[i];
        if (el.value !== undefined) data[el.name] = el.value;
      }

      var widget_name = klass.split(' ')[1];
      var widget_opts = this.registered_widgets[widget_name];

      // return if widget is not defined
      if (!widget_opts) {
        alert('Widget '+widget_name+' is not registred');
        return;
      }

      // define basic attributes
      var widget = {};
      for(i in Object.keys(widget_opts)) {
        key = Object.keys(widget_opts)[i];
        widget[key] = widget_opts[key];
      }

      if (! widget.init) { widget.init = function() {}; }
      if (! widget.render) { widget.render = function() {}; }

      // init, render and save
      widget.root = dom_node;
      widget.opts = data;
      widget.get = function(name) { return this.opts[name]; };
      widget.set = function(name, value) { 
        this.opts[name] = value;
        return value;
      };
      widget.destroy = function(name, value) {
        delete Widget.widgets[this.get('id')];
        this.root.parentNode.removeChild(this.root);
      };
      widget.inner_html = function(data) {
        this.root.innerHTML = data;
        Widget.load_all(this.root);
      };
      widget.init();
      widget.render();
      Widget.widgets[node_id] = widget;
    },

    is_widget: function(node) {
      var klass = node.getAttribute('class');
      if (! klass) { return undefined; }
      if (klass.split(' ')[0]==='w') { return node; }
    }
  };

  window.$w = function(node, widget_name) {
    var root = (function() {
      while (node) {
        if (Widget.is_widget(node)) { return node; }
        node = node.parentNode;
      }
    })();

    if (! root) { return alert('Widget node not found'); }


    return Widget.widgets[root.getAttribute('id')];
  };

}).apply(window);

Widget.load_all();
