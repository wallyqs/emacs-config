//si es Object object, deberia de hacer pretty print
// var $W = function(object){
//   return new $W.fn.init(object);
// };

var $W = {
  values: function (object){
    var results = [];
    for (var property in object){
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

