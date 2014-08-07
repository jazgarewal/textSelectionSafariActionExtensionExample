var TextSelectionClass = function() {};

TextSelectionClass.prototype = {
run: function(arguments) {

    arguments.completionFunction({"selectedText": window.getSelection().toString()});
},

finalize: function(arguments) {

}
};

var ExtensionPreprocessingJS = new TextSelectionClass;