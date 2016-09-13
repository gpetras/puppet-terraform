Facter.add("terraform_version") do
  setcode do
    terraform_version = Facter::Util::Resolution.exec('terraform version')
    terraform_version.split('\n').select{|line| line.start_with?('Terraform v')}.first.split[1] unless terraform_version.nil?
  end
end
