require 'spec_helper'

describe 'terraform' do

  default_facts = { staging_http_get: 'curl' }

  on_supported_os.each do |os,facts|

    default_facts = facts.merge(staging_http_get: 'curl', terraform_version: 'v0.6.11')

    case facts[:architecture]
    when 'amd64'
      _arch = 'amd64'
    when 'x86_64'
      _arch = 'amd64'
    when /i[345x]86/
      _arch = '386'
    end

    _os = facts[:kernel].downcase

    context "on #{os}" do

      let(:facts) { default_facts }

      it { should compile.with_all_deps }

      it 'should stage the default version' do
        should contain_class('terraform').with_version('0.6.11')
      end

      context 'with installed version equal to the requested version' do
        let(:facts) { default_facts }
        it 'should not stage the download' do
          should_not contain_staging__deploy("terraform_0.6.11_#{_os}_#{_arch}.zip")
        end
      end

      context 'with installed version different from the requested version' do
        let(:facts) { default_facts.merge(terraform_version: 'v0.6.10') }
        let(:params) {{ version: '0.6.12' }}
        it 'should stage the download of the specified version' do
          should contain_staging__deploy("terraform_0.6.12_#{_os}_#{_arch}.zip")
        end
      end

      context 'with no terraform_version' do
        let(:facts) { default_facts.merge(terraform_version: nil) }
        it 'should stage the download of the default version' do
          should contain_staging__deploy("terraform_0.6.11_#{_os}_#{_arch}.zip")
        end
      end
    end
  end
end
