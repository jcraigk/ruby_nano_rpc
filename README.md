# RaiblocksRpc

An RPC wrapper for RaiBlocks written in Ruby.  It provides a client you can call explicitly as well as proxy objects that make working with a Raiblocks node easier.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'raiblocks_rpc'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install raiblocks_rpc

## Usage

There are two ways to use this gem.  You can make direct calls to the RPC client or use proxy objects.

In either case, the client must first be configured to talk to your RaiBlocks node.  If you do not specify host or port before using the client, then `localhost:7076` will be used by default.

```ruby
  RaiblocksRpc::Client.host = 'localhost'
  RaiblocksRpc::Client.port = 7076
````

### Raw RPC Calls

You can use the RPC client to make raw RPC calls to a RaiBlocks node according to the documentation at [RaiBlocks RPC Docs](https://github.com/clemahieu/raiblocks/wiki/RPC-protocol).

Every call requires an `action`, which is passed as the first argument to `call`.  Depending on the action, there may be additional required or optional parameters that are passed as an options hash.

```ruby
  RaiblocksRpc::Client.instance.call(:account_balance, account: 'xrb_someaddress1234')
  # => {"balance"=>0, "pending"=>0}
````

Response data are provided as `Hashie` objects with integer coercion, indifferent access, and method access included.  Therefore you have several options for accessing values.

```ruby
  data = RaiblocksRpc::Client.instance.call(:account_balance, account: 'xrb_someaddress1234')
  # => {"balance"=>0, "pending"=>0}
  data.balance
  # => 0
  data[:balance]
  # => 0
  data['balance']
  # => 0
````

### Proxy Objects

Each namespace in the RaiBlocks RPC API is provided as a Ruby class with built-in helper methods.

For example, you can instantiate a new `RaiblocksRpc::Account` by passing in the account's public key.  You can then make calls on this object without needing to pass in the key for subsequent calls.

Methods with a common model prefix, such as `account_`, also have an abbreviated version so instead of calling `account_balance`, you can call simply `balance`.


```ruby
  account = RaiblocksRpc::Account.new('xrb_someaddress1234')

  data = account.balance
  => {"balance"=>0, "pending"=>0}
  data.balance
  => 0
  data.pending
  => 0

  data = account.weight
  => {"weight"=>13552245528000000000000000000000000}
  data.weight
  => 13552245528000000000000000000000000
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
