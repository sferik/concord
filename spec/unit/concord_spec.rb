# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Concord do
  let(:class_under_test) do
    Class.new { include Concord.new(:foo, :bar) }
  end

  context 'with initializer' do
    it 'creates a private #initialize method' do
      mod = Module.new
      expect { mod.send(:include, described_class.new) }
        .to change { mod.private_method_defined?(:initialize) }
        .from(false).to(true)
    end

    it 'asserts the number of arguments' do
      expect { class_under_test.new(1) }
        .to raise_error(ArgumentError, /wrong number of arguments/)
    end

    it 'allows the correct number of arguments' do
      expect { class_under_test.new(1, 2) }.not_to raise_error
    end

    it 'sets @foo instance variable' do
      expect(class_under_test.new(1, 2).instance_variable_get(:@foo)).to be(1)
    end

    it 'sets @bar instance variable' do
      expect(class_under_test.new(1, 2).instance_variable_get(:@bar)).to be(2)
    end
  end

  context 'with super calls' do
    let(:subclass) do
      Class.new do
        include Concord.new(:foo, :bar)

        public :foo, :bar
        attr_reader :sum

        def initialize(foo, bar)
          @sum = foo + bar
          super
        end
      end
    end

    it 'allows initialize to be called via super' do
      expect(subclass.new(1, 2).foo).to be(1)
    end

    it 'sets all instance variables via super' do
      expect(subclass.new(1, 2).bar).to be(2)
    end
  end

  context 'with no objects to compose' do
    it 'assigns no ivars' do
      instance = Class.new { include Concord.new }.new
      expect(instance.instance_variables).to be_empty
    end
  end

  context 'with visibility' do
    it 'sets attribute readers to protected' do
      expect(class_under_test.protected_instance_methods).to match_array(%i[foo bar])
    end

    it 'does not define readers on the Concord module itself' do
      expect(described_class.new(:foo, :bar)).not_to respond_to(:foo)
    end

    it 'does not raise when inspecting with protected readers' do
      expect { class_under_test.new(1, 2).inspect }.not_to raise_error
    end
  end

  context 'with module isolation' do
    it 'defines generated methods on the anonymous module, not the Concord instance' do
      concord = described_class.new(:foo, :bar)
      direct = concord.instance_methods(false) +
               concord.protected_instance_methods(false) +
               concord.private_instance_methods(false)
      expect(direct).not_to include(:foo, :bar, :initialize, :deconstruct, :deconstruct_keys, :cmp?)
    end

    it 'does not include Equalizer into the Concord instance directly' do
      concord = described_class.new(:foo, :bar)
      expect(concord.ancestors).to eq([concord])
    end
  end

  context 'with module inclusion' do
    it 'includes the generated module into the descendant' do
      ancestors = class_under_test.ancestors.map(&:class)
      expect(ancestors).to include(Module)
    end
  end

  context 'with attribute readers' do
    let(:foo) { Object.new }
    let(:bar) { Object.new }
    let(:instance) { class_under_test.new(foo, bar) }

    it 'returns foo via protected reader' do
      expect(instance.send(:foo)).to be(foo)
    end

    it 'returns bar via protected reader' do
      expect(instance.send(:bar)).to be(bar)
    end
  end

  context 'with equalization' do
    let(:foo) { Object.new }
    let(:bar) { Object.new }
    let(:instance_a) { class_under_test.new(foo, bar) }
    let(:instance_b) { class_under_test.new(foo, bar) }

    it 'considers objects with same attributes as eql' do
      expect(instance_a).to eql(instance_b)
    end

    it 'produces same hash for eql objects' do
      expect(instance_a.hash).to eql(instance_b.hash)
    end

    it 'does not consider objects with different attributes as eql' do
      expect(instance_a).not_to eql(class_under_test.new(foo, Object.new))
    end

    it 'compares as == with same attributes' do
      expect(instance_a == instance_b).to be(true)
    end

    it 'does not == with different attributes' do
      expect(instance_a == class_under_test.new(foo, Object.new)).to be(false)
    end
  end

  context 'with pattern matching' do
    it 'deconstructs attribute values in order' do
      expect(class_under_test.new(1, 2).deconstruct).to eql([1, 2])
    end

    it 'deconstructs all keys when nil is passed' do
      expect(class_under_test.new(1, 2).deconstruct_keys(nil)).to eql(foo: 1, bar: 2)
    end

    it 'deconstructs only requested keys' do
      expect(class_under_test.new(1, 2).deconstruct_keys([:foo])).to eql(foo: 1)
    end

    it 'ignores unknown keys' do
      expect(class_under_test.new(1, 2).deconstruct_keys([:baz])).to eql({})
    end
  end

  context 'with method visibility' do
    it 'defines cmp? as private' do
      expect(class_under_test.private_method_defined?(:cmp?)).to be(true)
    end

    it 'does not expose initialize as public' do
      expect(class_under_test.public_method_defined?(:initialize)).to be(false)
    end

    it 'does not make initialize public on the generated module' do
      mod = Module.new
      mod.send(:include, described_class.new(:x))
      expect(mod.public_method_defined?(:initialize)).to be(false)
    end

    it 'makes initialize private on the generated module' do
      mod = Module.new
      mod.send(:include, described_class.new(:x))
      expect(mod.private_method_defined?(:initialize)).to be(true)
    end
  end

  context 'when composing too many objects' do
    it 'raises an error for more than 3 objects' do
      expect { described_class.new(:a, :b, :c, :d) }
        .to raise_error(RuntimeError, 'Composition of more than 3 objects is not allowed')
    end

    it 'allows up to 3 objects' do
      expect { described_class.new(:a, :b, :c) }.not_to raise_error
    end
  end

  describe Concord::Public do
    let(:class_under_test) do
      Class.new { include Concord::Public.new(:foo, :bar) }
    end

    it 'creates public foo reader' do
      expect(class_under_test.new(:foo, :bar).foo).to be(:foo)
    end

    it 'creates public bar reader' do
      expect(class_under_test.new(:foo, :bar).bar).to be(:bar)
    end
  end
end
