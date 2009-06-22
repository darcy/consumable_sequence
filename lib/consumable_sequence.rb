class ConsumableSequence < ActiveRecord::Base

  def self.get(scope='default')
    transaction do
      seq = find_by_scope(scope, :lock => 'for update')
      if seq
        newseq = seq.sequence+=1
        seq.update_attribute('sequence',newseq)
        newseq
      else
        create!(:scope => scope, :sequence => 1)
        1
      end
    end
  end
  
  def self.offset(scope, amt)
    transaction do
      seq = find_by_scope(scope, :lock => 'for update')
      if seq
        newseq = seq.sequence+=amt
        seq.update_attribute('sequence',newseq)
        newseq
      else
        create!(:scope => scope, :sequence => amt)
        amt
      end
    end
  end
  
end