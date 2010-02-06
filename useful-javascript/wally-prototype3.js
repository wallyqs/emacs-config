//si es Object object, deberia de hacer pretty print
// var $W = function(object){
//   return new $W.fn.init(object);
// };

// ========================================================================
// SI SE TRATA DE UNA PROPIEDAD DEBERIA DE
// hacer el output y ya
// falta lo de hacer el pretty print de un objeto de JSON por ejemplo...
// y el wrapper a ver que tal se veria

var $WW = {
  attributes: function (object){
    var results = [];
    var property_counter = 0;
    for (var property in object){
      property_counter += 1 ;
      var cell =  property + ": ";
      if (typeof object[property] === "function"){
        // cell += "function";
        // results.push(cell);
      }
      else {
        cell += object[property];
        results.push(cell);
      }
    }
    if(property_counter == 0){   results.push(object); }
    return results;
  },
  methods: function(object){
    var results = [];
    for (var property in object){
      var cell = "";
      if (typeof object[property] === "function"){
        cell += property;
        results.push(cell);
      }
    }
    return results;
  }
};


var $W = function(object){
  this.attributes = this.values = function(){
    var results = [];
    var property_counter = 0;
    for (var property in object){
      property_counter += 1 ;
      var cell =  property + ": ";
      if (typeof object[property] === "function"){
        // cell += "function";
        // results.push(cell);
      }
      else {
        cell += object[property];
        results.push(cell);
      }
    }
    if(property_counter == 0){   results.push(object); }
    return results;
  }();
  this.methods = function(){
    var results = [];
    for (var property in object){
      var cell = "";
      if (typeof object[property] === "function"){
        cell += property;
        results.push(cell);
      }
    }
    return results;
  }();

  //no se puede usar mas que en Rhino
  this.print_methods = function(){
    for (var property in object){
      // if (typeof object[property] === "function"){
	print(property);
      // }
    }
  };


  if (this instanceof $W){
    return this.$W;
  } else {
    return new $W(object);
  };

};