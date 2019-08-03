const keys = require('./keys');
const redis = require('redis');

// Setup redis config
const redisClient = redis.createClient({
  host: keys.redisHost,
  port: keys.redisPort,
  retry_strategy: () => 1000
});
// Create duplicate of the client to subscribe to
const sub = redisClient.duplicate();

// Fibonacci function calculator
function fib(index) {
  if (index < 2) return 1;
  return fib(index - 1) + fib(index - 2);
}

// Listen to new values that show up in the duplicate
sub.on('message', (channel, message) => {
  // Calculate value and insert into hash 'values'
  redisClient.hset('values', message, fib(parseInt(message)));
});
// Subscribe to the 'insert' event
sub.subscribe('insert');
