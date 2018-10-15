describe User do
  let(:user) { User.create(card_number: 1111222233334444, pin: 1111, balance: 1000, attempts: 0) }

  describe 'instance methods' do
    it do  should respond_to(:pin,
                             :card_number,
                             :balance,
                             :attempts,
                             :status,
                             :authorization,
                             :correct_pin,
                             :incorrect_pin,
                             :block_required?,
                             :reset_attempts,
                             :block!,
                             :unlock!,
                             :attempts_left,
                             :authorized?)
    end

    it "#card_number returns integer" do
      expect(user.card_number).to eq 1111222233334444
    end

    it "#pin returns integer" do
      expect(user.pin).to eq 1111
    end

    it "#balance returns integer" do
      expect(user.balance).to eq 1000
    end

    it "#attempts returns integer" do
      expect(user.attempts).to eq 0
    end

    it "#attempts_left returns integer" do
      expect(user.attempts_left).to eq 3
    end

    it "#status returns string" do
      expect(user.status).to eq 'active'
    end

    it "#authorization returns string" do
      expect(user.authorization).to eq 'unperformed'
    end

    it "#block_required? returns bool" do
      expect(user.block_required?).to eq false
    end

    it "#authorized? returns bool" do
      expect(user.authorized?).to eq false
    end

    it "#block! blocks the card" do
      user.block!
      expect(user.blocked?).to eq true
    end

    it "#unlock! unlocks the card" do
      3.times { user.incorrect_pin }
      expect(user.attempts_left).to eq 0
      user.unlock!
      expect(user.attempts_left).to eq 3
      expect(user.blocked?).to eq false
    end

    it "#inorrect_pin increase attempts or block card if it is required" do
      user.incorrect_pin
      expect(user.attempts).to eq 1
      2.times { user.incorrect_pin }
      expect(user.blocked?).to eq true
    end

    it "#correct_pin sets attempts to zero and unlock card if it isn't blocked" do
      user.incorrect_pin
      expect(user.attempts).to eq 1
      user.correct_pin
      expect(user.attempts).to eq 0
      3.times { user.incorrect_pin }
      expect(user.blocked?).to eq true
      user.correct_pin
      expect(user.blocked?).to eq true
    end

    it "#reset_attempts set attempts to zero" do
      user.incorrect_pin
      expect(user.attempts).to eq 1
      user.reset_attempts
      expect(user.attempts).to eq 0
    end
  end

  describe 'validations' do
    context 'card_number' do
      it 'should present' do
        user.card_number = nil
        expect(user).to be_invalid
      end

      it 'should be numeric' do
        user.card_number = "one_million"
        expect(user).to be_invalid
      end

      it 'should contains 16 numbers' do
        user.card_number = 1111
        expect(user).to be_invalid
      end
    end

    context 'pin' do
      it 'should present' do
        user.pin = nil
        expect(user).to be_invalid
      end

      it 'should be numeric' do
        user.pin = "one_hundred"
        expect(user).to be_invalid
      end

      it 'should contains 4 numbers' do
        user.pin = 11112222
        expect(user).to be_invalid
      end
    end

    context 'attempts' do
      it 'should present' do
        user.attempts = nil
        expect(user).to be_invalid
      end

      it 'should be positive' do
        user.attempts = -1
        expect(user).to be_invalid
      end
    end

    context 'balance' do
      it 'should present' do
        user.balance = nil
        expect(user).to be_invalid
      end

      it 'should be positive' do
        user.balance = -1
        expect(user).to be_invalid
      end
    end

    context 'status' do
      it 'should present' do
        user.status = nil
        expect(user).to be_invalid
      end
    end

    context 'authorization' do
      it 'should present' do
        user.authorization = nil
        expect(user).to be_invalid
      end
    end
  end
end
