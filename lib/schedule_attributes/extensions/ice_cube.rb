class IceCube::Rule
  def ==(other)
    return false unless other.present?
    to_hash == other.to_hash
  end
end

class IceCube::Schedule
  def ==(other)
    return false unless other.present?
    to_hash == other.to_hash
  end
end
