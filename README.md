# Installer

Build installer iso using `make build/out/installer.iso`.

You can try the image using `make qemu`.

## Testing

```
# Start the fake deplyoment infra and register your pubkey
# If you do not have one, you have to generate one first
$ python3 fake-infra.py ~/.ssh/id_ed25519.pub
# Build the installer and start a local VM
$ make qemu
# In a new terminal, ssh to the installer
$ ssh root@localhost -p 5555 -i ~/.ssh/id_ed25519
```
