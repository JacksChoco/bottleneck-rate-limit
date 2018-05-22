var rp = require("request-promise");
var Bottleneck = require("bottleneck");


// Restrict us to one request per second
var limiter = new Bottleneck(1, 1000);


var locations = ["London","Paris","Rome","New York","Cairo"];

// fire off requests for all locations
Promise.all(locations.map(function (location) {

    // set up our request
    var options = {
        uri: 'https://weatherwebsite.com?location=' + location,
        json: true
    };

    // run the api call. If we weren't using bottleneck, this line would have just been
    // return rp(options)
    //    .then(function (response) {...
    //
    return limiter.schedule(rp,options)
        .then(function (response) {
            console.log('Weather data is', response);
        })
        .catch(function (err) {
            // API call failed...
        });
}))