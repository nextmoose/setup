# setup

Use gdisk to partition your drive to look like

```
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          411647   200.0 MiB   EF00  EFI System
   2          411648        17188863   8.0 GiB     8200  Linux swap
   3        17188864      1953525134   923.3 GiB   8300  Linux filesystem

```


## Getting Started

### Preparation

Use `gdisk` to wipe your disk clean.
I like `gdisk /dev/sda`.
Then

curl --location --