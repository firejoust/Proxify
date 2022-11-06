<div align="center">
    <h2>Proxify</h2>
    <p align="center">A TCP tunneler</p>
</div>

### Features
- Proxy TCP packets from point A to point B
- Plug & play
- DNS Support

### Dependencies
- This program requires [Crystal](https://crystal-lang.org/install/) to be installed on the user's machine

### Installation
- `git clone https://github.com/firejoust/proxify` 1. Clone the project
- `cd proxify` 2. Enter the project directory
- `crystal build --release src/proxify.cr` 3. Build the executable

### Usage
```
Usage: proxify [args]
    -a, --bind-address <address>     The address to listen on
    -p, --bind-port <port>           The port to listen on
    -A, --remote-address <address>   The address to forward to
    -P, --remote-port <port>         The port to forward to

```

### Contributing
1. Fork it (<https://github.com/your-github-user/proxify/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request