require_relative '../configurations/list_configuration'

class NoHTTPRule < Rule
  @name="No HTTP Connections"

  def self.AnalyzeTokens(tokens)
    result = ""

    tokens.each do |indi_token|
      token_valu = indi_token.value ### this gives each token
      token_valu = token_valu.downcase
      token_type = indi_token.type.to_s
      if (token_valu.include? "http://" ) && (!token_type.eql? "COMMENT")
        result += {
          message: 'SECURITY:::HTTP:::Do not use HTTP without TLS. This may cause a man in the middle attack. Use TLS with HTTP.',
          line:    indi_token.line,
          column:  indi_token.column,
          token:   token_valu
        }.to_s+"\n"
      end
    end

    return result
  end

end