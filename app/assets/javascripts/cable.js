
console.log("Hello!");
this.App || (this.App = {});
App.cable = ActionCable.createConsumer(`ws://some.host:28080`);
console.log("Created Connection:");
console.log(App.cable);