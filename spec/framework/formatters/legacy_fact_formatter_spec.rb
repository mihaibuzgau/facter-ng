# frozen_string_literal: true

describe 'LegacyFactFormatter' do
  it 'formats to legacy when no user query' do
    resolved_fact1 =
      double(Facter::ResolvedFact, name: 'os.name', value: 'Darwin', user_query: '', filter_tokens: [])
    resolved_fact2 =
      double(Facter::ResolvedFact, name: 'os.family', value: 'Darwin', user_query: '', filter_tokens: [])
    resolved_fact3 =
      double(Facter::ResolvedFact, name: 'os.architecture', value: 'x86_64', user_query: '', filter_tokens: [])
    resolved_fact_list = [resolved_fact1, resolved_fact2, resolved_fact3]

    formatted_output = Facter::LegacyFactFormatter.new.format(resolved_fact_list)

    expected_output = "os => {\n  architecture => \"x86_64\",\n  family => \"Darwin\",\n  name => \"Darwin\"\n}"

    expect(formatted_output).to eq(expected_output)
  end

  it 'formats to legacy for a single user query' do
    resolved_fact =
      double(Facter::ResolvedFact, name: 'os.name', value: 'Darwin', user_query: 'os.name', filter_tokens: [])
    resolved_fact_list = [resolved_fact]
    formatted_output = Facter::LegacyFactFormatter.new.format(resolved_fact_list)

    expected_output = 'Darwin'

    expect(formatted_output).to eq(expected_output)
  end

  it 'formats to legacy for a single user query that contains :' do
    resolved_fact =
      double(Facter::ResolvedFact, name: 'networking.ip6', value: 'fe80::7ca0:ab22:703a:b329',
                                   user_query: 'networking.ip6', filter_tokens: [])
    resolved_fact_list = [resolved_fact]
    formatted_output = Facter::LegacyFactFormatter.new.format(resolved_fact_list)

    expected_output = 'fe80::7ca0:ab22:703a:b329'

    expect(formatted_output).to eq(expected_output)
  end

  it 'formats to legacy for multiple user queries' do
    resolved_fact1 =
      double(Facter::ResolvedFact, name: 'os.name', value: 'Darwin', user_query: 'os.name', filter_tokens: [])
    resolved_fact2 =
      double(Facter::ResolvedFact, name: 'os.family', value: 'Darwin', user_query: 'os.family', filter_tokens: [])
    resolved_fact_list = [resolved_fact1, resolved_fact2]
    formatted_output = Facter::LegacyFactFormatter.new.format(resolved_fact_list)

    expected_output = "os.family => Darwin\nos.name => Darwin"

    expect(formatted_output).to eq(expected_output)
  end

  it 'formats to legacy for empty resolved fact array' do
    formatted_output = Facter::LegacyFactFormatter.new.format([])

    expect(formatted_output).to eq(nil)
  end

  it 'returns empty string when the fact value is nil' do
    resolved_fact1 =
      double(Facter::ResolvedFact, name: 'my_external_fact',
                                   value: nil, user_query: 'my_external_fact', filter_tokens: [])
    resolved_fact_list = [resolved_fact1]

    formatted_output = Facter::LegacyFactFormatter.new.format(resolved_fact_list)
    expect(formatted_output).to eq('')
  end
end
