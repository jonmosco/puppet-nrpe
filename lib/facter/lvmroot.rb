# This will gather the root partition information
# for NRPE.
# First custom fact

Facter.add("root_partition") do
  #confine :kernel => "Linux"
  confine :kernel => :linux
  setcode do
    # problem: if the partion was created with kickstart, it will not have a 
    # name associated with it, just a UUID.  If this is the case, get our 
    # partion name from df -h ?
    Facter::Util::Resolution.exec('/bin/df -h | sed -n 2p')
    #Facter::Util::Resolution.exec('grep "/ " /etc/fstab | sed "s/\ .*//"'')
  end
end
