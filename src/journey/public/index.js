import journey from 'ic:canisters/journey';

journey.greet(window.prompt("Enter your name:")).then(greeting => {
  window.alert(greeting);
});
