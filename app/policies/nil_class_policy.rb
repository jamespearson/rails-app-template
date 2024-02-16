class NilClassPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        raise Pundit::NotDefinedError, "Cannot scope NilClass"
      end
    end
  
    def show?
      false # Nobody can see nothing
    end
  
    def update?
      false # Nobody can update nothing
    end
  
    def delete?
      false # Nobody can delete nothing
    end
  end