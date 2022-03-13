[![Gem Version](https://badge.fury.io/rb/nano_rpc.svg)](https://badge.fury.io/rb/nano_rpc)
![Gem Downloads](https://ruby-gem-downloads-badge.herokuapp.com/nano_rpc?type=total)
[![Build Status](https://travis-ci.org/jcraigk/ruby_nano_rpc.svg?branch=main)](https://travis-ci.org/jcraigk/ruby_nano_rpc)
[![CodeCov](https://codecov.io/gh/jcraigk/ruby_nano_rpc/branch/main/graph/badge.svg)](https://codecov.io/gh/jcraigk/ruby_nano_rpc)
[![Maintainability](https://api.codeclimate.com/v1/badges/a99a88d28ad37a79dbf6/maintainability)](https://codeclimate.com/github/codeclimate/codeclimate/maintainability)

![Ruby Nano RPC Logo](https://i.imgur.com/ihmmYcp.png)

Nano RPC is a Ruby wrapper for making Remote Procedure Calls against Nano digital currency nodes. Arbitrary RPC access is provided along with proxy objects that expose helper methods ([Wiki](https://github.com/jcraigk/ruby_nano_rpc/wiki)).

To run a Nano node locally, see [Nano Docker Docs](https://github.com/clemahieu/raiblocks/wiki/Docker-node).

| Gem version | Nanocurrency version |
|-------------|----------------------|
| 0.26        | >= 19.0              |
| 0.25        | >= 18.0, < 19.0      |
| 0.24        | >= 17.0, < 18.0      |
| 0.23        | >= 16.0, < 17.0      |
| 0.20        | >= 15.0, < 16.0      |
| 0.19        | >= 14.2, < 15.0      |

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nano_rpc'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nano_rpc

## Usage

There are two ways to use this gem.  You can use proxy objects that expose helper methods or you make direct RPC calls using Ruby hashes.

### Proxy Objects / Helper Methods

Proxy objects are provided to ease interaction with the API by providing logically grouped helper methods. Here we do not strictly follow the grouping as expressed in the [Nano RPC Docs](https://github.com/clemahieu/raiblocks/wiki/RPC-protocol).  Instead, the following objects are provided:

* [NanoRpc::Account](https://github.com/jcraigk/ruby_nano_rpc/wiki/NanoRpc::Account)
* [NanoRpc::Accounts](https://github.com/jcraigk/ruby_nano_rpc/wiki/NanoRpc::Accounts)
* [NanoRpc::Node](https://github.com/jcraigk/ruby_nano_rpc/wiki/NanoRpc::Node)
* [NanoRpc::Wallet](https://github.com/jcraigk/ruby_nano_rpc/wiki/NanoRpc::Wallet)

`Account`, `Accounts`, and `Wallet` each require a single parameter to be passed during initialization (`address`, `addresses`, and `id`, respectively).  This parameter is persisted for subsequent calls.  All RPC methods are provided directly as methods.

```ruby
account = NanoRpc.node.account('xrb_1234') # Account address required
accounts = NanoRpc.node.accounts(%w[xrb_1234 xrb_456]) # Array of account addresses required
wallet = NanoRpc.node.wallet('3AF91AE') # Wallet id required
```

You can call standard RPC methods on each object:

```ruby
account.account_balance
# => {"balance"=>100, "pending"=>5}
account.account_balance.balance
# => 100
```

There are also helper methods to bypass repetitive nested calls:

```ruby
account.balance
# => 100
account.pending_balance
# => 5
```

To convert from Nano to raw and back, use `#to_raw` and `#to_nano`, available on all `Numeric` objects:

```ruby
4622800482000000000000000000000000.to_nano
# => 4622.800482

4622.800482.to_raw
# => 4622800482000000000000000000000000
```

For a comprehensive guide, see the [Wiki](https://github.com/jcraigk/ruby_nano_rpc/wiki).

### Direct RPC Calls

The NanoRpc::Node object exposes raw Remote Procedure Call methods according to the [Nano RPC Docs](https://github.com/clemahieu/raiblocks/wiki/RPC-protocol).

Every method requires an `action`, which is passed as the first argument to `call`.  Depending on the action, there may be additional required or optional parameters that are passed as an options hash.

First setup the node connection:

```ruby
# Connect to the default node (localhost:7076)
node = NanoRpc.node

# or connect to a custom node
node = NanoRpc::Node.new(host: 'mynanonode', port: 1234)
```

If you're using [Nanode](https://www.nanode.co/) or similar service that requires `Authorization` key in HTTP header, you can specify it using `auth`:

```ruby
node = NanoRpc::Node.new(auth: 'someauthkey')
```

You can also specify custom headers as a hash and they will be sent with every RPC request:

```ruby
node = NanoRpc::Node.new(headers: { 'Authorization' => 'someauthkey' })
```

The default timeout for each request is 20 seconds but you can specify a custom value:

```ruby
node = NanoRpc::Node.new(timeout: 10)
```

Once the node is setup, use the `call` method, passing in action and params:

```ruby
node.call(:account_balance, account: 'xrb_1234')
# => {"balance"=>100, "pending"=>0}
```

Response data are provided as [Hashie](https://github.com/intridea/hashie) objects with integer coercion, indifferent access, and method access.

```ruby
data.balance
# => 100
data[:balance]
# => 100
data['balance']
# => 100
```

## Credits

Logo created by Andrei Luca ([Twitter](https://twitter.com/lucandrei_))

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
