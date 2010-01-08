// No se puede usar Object.prototype porque arruina
// los objetos normales de javascript
//
// Ejemplo:
// var novia = {
//   nombre: "Mariko!!!",
//   apellido: "Minami!!!",
//   say: function (){
//     return this.nombre + " " + this.apellido;
//   }
// };

// var $W = {};

// $W.prototype = function(){
//     print("holaaa!!");
// };

//si es Object object, deberia de hacer pretty print
var $W = {
  values: function (object){
    var results = [];
    for (var property in object){
      var cell =  property + ": ";
      if (typeof object[property] === "function"){
        // cell += "function";
        // results.push(cell);
      }
      else if (typeof object[property] === "object"){
	cell += $W.values(property);
	results.push(cell);
      } else {
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

// ========================================================================
// values TE DIRIA QUE PROPIEDADES TIENE UN OBJETO
// function values(object) {
//   var results = [];
//   for (var property in object){
//     var cell =  property + ": ";
//     if (typeof object[property] === "function"){
//       // cell += "function";
//       // results.push(cell);
//     }
//     else {
//       cell += object[property];
//       results.push(cell);
//     }
//   }
//   return results;
// }

// METHODS TE DICE QUE FUNCIONES TIENE
// function methods(object) {
//   var results = [];
//   for (var property in object){
//     var cell = "";
//     if (typeof object[property] === "function"){
//       cell += property;
//       results.push(cell);
//     }
//   }
//   return results;
// }