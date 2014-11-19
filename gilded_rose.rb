require 'delegate'

class ItemProxy
  attr_reader :item
  def initialize(item)
    @item = item
  end

  def update
    update_quality_before_expiration
    
    age!
    
    if expired?
      update_quality_after_expiration
    end
  end

  private
  
  def conjured?
    item.name == 'Conjured Mana Cake'
  end

  def decrease_quality
    if conjured?
      item.quality -= 2
    else
      item.quality -= 1
    end
  end
  
  def age!
    if item.name != 'Sulfuras, Hand of Ragnaros'
      item.sell_in -= 1
    end
  end
  
  def expired?
    item.sell_in < 0
  end
  
  def update_quality_before_expiration
    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      if item.quality > 0
        if item.name != 'Sulfuras, Hand of Ragnaros'
          decrease_quality
        end
      end
    else
      if item.quality < 50
        item.quality += 1
        if item.name == 'Backstage passes to a TAFKAL80ETC concert'
          if item.sell_in < 11
            if item.quality < 50
              item.quality += 1
            end
          end
          if item.sell_in < 6
            if item.quality < 50
              item.quality += 1
            end
          end
        end
      end
    end
  end
  
  def update_quality_after_expiration
    if item.name != "Aged Brie"
      if item.name != 'Backstage passes to a TAFKAL80ETC concert'
        if item.quality > 0
          if item.name != 'Sulfuras, Hand of Ragnaros'
            decrease_quality
          end
        end
      else
        item.quality = 0
      end
    else
      if item.quality < 50
        item.quality += 1
      end
    end
  end
end



def update_quality(items)
  items.each do |item|
    ItemProxy.new(item).update
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

