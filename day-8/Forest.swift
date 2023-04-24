//
// Advent of Code 2022
// Day 8: Treetop Tree House
//

struct Forest: CustomStringConvertible {
    let rows: [[Tree]]
    let columns: [[Tree]]
    
    var description: String {
        var desc = ""
        
        for row in rows {
            for tree in row {
                desc.append(tree.description)
            }
            
            desc.append("\n")
        }
        
        return desc
    }

    init(from heightMap: String) {
        let forest = Forest.parseForest(from: heightMap)
        
        rows = forest.rows
        columns = forest.columns
    }
    
    static func parseForest(from heightMap: String) -> (rows: [[Tree]], columns: [[Tree]]) {
        var rows: [[Tree]] = []
        var columns: [[Tree]] = []
        
        for row in heightMap.components(separatedBy: "\n") {
            var currentRow: [Tree] = []
            
            for (i, height) in row.enumerated() {
                let tree = Tree(height: Int(String(height))!)
                
                if let westTree = currentRow.last {
                    tree.west = westTree
                    westTree.east = tree
                }
                
                currentRow.append(tree)
                
                if columns.indices.contains(i) {
                    if let northTree = columns[i].last {
                        tree.north = northTree
                        northTree.south = tree
                    }
                    
                    columns[i].append(tree)
                } else {
                    columns.append([tree])
                }
            }
            
            rows.append(currentRow)
        }
        
        return (rows: rows, columns: columns)
    }
    
    func calculateVisibility() {
        for row in rows {
            var tallest = -1
            
            for tree in row {
                if tree.height > tallest {
                    tree.westVisible = true
                    tallest = tree.height
                }
                
                if tree.height == 9 {
                    break
                }
            }
            
            tallest = -1
            for tree in row.reversed() {
                if tree.height > tallest {
                    tree.eastVisible = true
                    tallest = tree.height
                }
                
                if tree.height == 9 {
                    break
                }
            }
        }
        
        for column in columns {
            var tallest = -1
            
            for tree in column {
                if tree.height > tallest {
                    tree.northVisible = true
                    tallest = tree.height
                }
                
                if tree.height == 9 {
                    break
                }
            }
            
            tallest = -1
            for tree in column.reversed() {
                if tree.height > tallest {
                    tree.southVisible = true
                    tallest = tree.height
                }
                
                if tree.height == 9 {
                    break
                }
            }
        }
    }
}
