# This will gather the root partition information
# for NRPE.
# First custom fact

Facter.add("root_partition") do
  confine :kernel => "Linux"
  setcode do
    Facter::Util::Resolution.exec('/bin/df -h | sed -n 2p')
  end
end
