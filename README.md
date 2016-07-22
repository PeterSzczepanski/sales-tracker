# Price Tracker

Tracks sales information for different product with an external vendor's api. Project instructions is located in `Instructions.md`.

## Setup Instructions

```
# Initial vendor needs to be created
bundle exec rake prod_seed:vendor
```

## Gems

### Production

* `rest-client` - Vendor HTTP Requests
* `money-rails` - handles conversion from dollars to cents, with `Money` object

### Testing

* `pry` - debugger console, very useful
* `rspec-rails` - rspec for rails
* `shoulda-matchers` - useful matchers for testing models
* `webmock` - stub out http requests

## Assumptions

* Started setting up structure for multiple vendors
* API uses ISO 8601 `YYYY-MM-DD` 
* Price changes could be modified without the `product_updater` script.
* kept `product_name` as it said in the spec but should be `product`
* Rail logs will be monitored. Better solution is to use a log monitoring service like `honeybadger`
or `sentry` for alerts.