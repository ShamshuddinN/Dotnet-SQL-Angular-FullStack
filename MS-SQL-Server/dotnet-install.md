# Setting up dotnet dev

Install dotnet 8:

```bash
sudo dnf install dotnet-sdk-8.0
```

Install dotnet ef [Entity Framework]:

```bash
dotnet tool install --global dotnet-ef
```

## Then need to add dotnet-ef to path. Otherwise it won't be invocable.

To add to path:

```bash
sudo nano ~/.bashrc
```

Add below line (verify the folder existance once):

```bash
export PATH="$PATH:$HOME/.dotnet/tools"
```